#!/usr/bin/env ruby

require 'optparse'
require 'CSV'
require 'pp'

# 用法：
#    先手动对 numbers 文档做一些预处理：
#      1. 删除上课和 Android 离线存储这两页
#      2. 删除标为红色的行
#
#    A方法：(不用手动导出csv, 需要保证 numbers 当前只打开了 frog 文档)
#      运行 ./Tools/parseFrog.rb -p TTCounter -o TutorEmbedded/Core/Utils/Constants/TTGeneratedLogConstants
#
#    B方法：
#      1. 把产品 frog 文档用 numbers 打开，导出成 csv，numbers 会导出成一个目录，例如放在了 ~/frog
#      2. 运行 ./Tools/parseFrog.rb ~/frog -p TTCounter -o TutorEmbedded/Core/Utils/Constants/TTGeneratedLogConstants
#      3. 会在目标目录生成 TTGeneratedLogConstants.h 和 TTGeneratedLogConstants.m
class FrogParser
  def parse_cli_option!
    @options = {}

    optionParser = OptionParser.new do |opts|
      opts.banner = "Usage: parseFrog [options] inputFilePath/Directory"

      opts.on("-oOUTPUT", "--output=OUTPUT", "Output file path without suffix, eg. ./GeneratedConstant") do |p|
        @options[:outputPath] = p
      end

      opts.on("-pPREFIX", "--prefix=PREFIX", "Constant\'s prefix") do |p|
        @options[:prefix] = p
      end
    end

    optionParser.parse!

    if @options.length < 2
      puts optionParser.help
      exit
    end

    @options[:inputTarget] = ARGV[0]
  end

  def get_csv_content!
    csv_files = nil
    if @options[:inputTarget]
      csv_files = Dir[@options[:inputTarget] + "/*.csv"]
    else
      system "rm -rf /private/tmp/frog.csv"
      system "osascript #{File.dirname(__FILE__)}/convert.scpt"
      csv_files = Dir["/private/tmp/frog.csv/*.csv"]
    end
    @arr_of_frogs = []
    csv_files.each do |f|
      @arr_of_frogs += CSV.read(f)
    end

    @arr_of_frogs.each do |f|
      f.compact!
    end
  end

  def parse_csv_content!
    url_regex = /\/?(click|event)\//  # 容错机制：有的 url 产品会漏写 / 开头

    @h_result = ""
    @m_result = ""
    frog_dic = Hash.new(0)
    @arr_of_frogs.each do |row|
    # 容错机制：产品会忘了给 URL 的那一列写 url，也会忘了给第二列写说明，所以从第3列一直尝试到第1列检测符合条件的 url
      if row[2] =~ url_regex
        target_url = row[2].strip
      elsif row[1] =~ url_regex
        target_url = row[1].strip
      elsif row[0] =~ url_regex
        row[0].strip =~ /.*[#＃]?(\/(click|event)\/.*?)[#＃]/
        target_url = $1
      else
        next # 不包含 url 的 row 跳过
      end

    # 容错机制：对于漏写 / 开头的 url，给他加上 /
      if target_url[0] != "/"
        target_url = "/" + target_url
      end
      pp target_url
      frog_variable =  target_url
          .split(/-|\/+/) # 容错机制：url 里面可能有 - ，产品也可能把 / 写成 //，比如/event//giveMoney
          .drop(2)
          .map do |word|
            word[0] = word[0].capitalize
            word
          end
          .inject(:+)

      if @options.has_key?(:prefix)
        frog_variable = @options[:prefix] + frog_variable
      end

    # 因为忽略了 event/click 前缀，frog 变量可能重名，重名的话在重名的 frog 变量后加上 ordinal，但这不影响 url
      if frog_dic[frog_variable] > 0
        new_frog_variable = frog_variable += String(frog_dic[frog_variable])
        @m_result += "\nNSString *const #{new_frog_variable} = @\"#{target_url}\";"
        @h_result += "\nextern NSString *const #{new_frog_variable}; //#{row[0]}"
      else
        @m_result += "\nNSString *const #{frog_variable} = @\"#{target_url}\";"
        @h_result += "\nextern NSString *const #{frog_variable}; //#{row[0]}"
      end
      frog_dic[frog_variable] += 1
    end
  end

  def write_to_output_path
    File.open(@options[:outputPath] + ".h", "w") do |f|
      f.write @h_result + "\n"
    end

    File.open(@options[:outputPath] + ".m", "w") do |f|
      f.write @m_result + "\n"
    end
  end

  def self.run
    parser = self.new
    parser.parse_cli_option!
    parser.get_csv_content!
    parser.parse_csv_content!
    parser.write_to_output_path
  end
end

FrogParser.run
