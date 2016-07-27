require 'open3'
module GenerateHelper
  BASE_DIR = "#{Rails.root}/tmp/output"
  NUGET_DIR = "#{Rails.root}/tmp/output/nugets"

  def generate_tgz(dir_path, file)
    execute("tar -zvcf #{file}.tar.gz -C #{dir_path} .")
    "#{Rails.root}/#{file}.tar.gz"
  end

  def execute_autorest(autorest_version, cmd_line_arguments, timestamp=nil)

    args = cmd_line_arguments.map{|k,v| "#{k} #{v.to_s}" unless (v.nil? or v.to_s.empty?)}.join(' ')
    puts "AutoRest Arguments: #{args}"
    puts "Installing AutoRest version: #{autorest_version}"
    execute("nuget install AutoRest -Source https://www.myget.org/F/autorest/ -pre -OutputDirectory #{NUGET_DIR} -Version #{autorest_version}")

    puts "Executing AutoRest..."

    if timestamp
      zip_dir = BASE_DIR + '/' + timestamp
      execute("mkdir -p #{zip_dir}")
      log = execute("mono #{NUGET_DIR}/AutoRest.#{autorest_version}/tools/AutoRest.exe #{args}")
      File.open("#{zip_dir}/log.txt", 'w') { |file| file.write(log) }

      puts "Generating tar.gz..."
      generate_tgz(zip_dir, timestamp)
    else
      execute_validate("mono #{NUGET_DIR}/AutoRest.#{autorest_version}/tools/AutoRest.exe #{args}")
    end


  end

  def execute(cmd)
    errors = ''
    Open3.popen3(cmd) do |_, stdout, stderr, wait_thr|
      while line = stderr.gets
        errors = errors + line
        puts 'err:' + line
      end

      exit_status = wait_thr.value

      if exit_status.success?
        stdout.read
      else
        raise AutoRestGenerationError.new(errors)
      end
    end
  end

  def execute_validate(cmd)
    errors = ''
    Open3.popen2e(cmd) do |_, stdout_and_stderr, _|
      while line = stdout_and_stderr.gets
        errors = errors + line
        puts 'err:' + line
      end
    end
    errors
  end

  class AutoRestGenerationError < StandardError
    attr_reader :msg
    def initialize(msg="AutoRest generation failed.")
      @msg = msg
      super
    end
  end
end
