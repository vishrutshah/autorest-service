class GenerateController < ApplicationController
  include GenerateHelper

  def client

  end

  def create
    params.to_s
    puts "We'll pass this parameters to the AutoRest and collect gzip to be sent back."

    autorest_version = params[:autorestVersion]
    spec_url = params[:specUrl]
    add_credentials = params[:addCredentials]
    client_name = params[:clientName]
    code_generator = params[:codeGenerator]
    header = params[:header]
    modeler = params[:modeler]
    namespace = params[:namespace]
    package_name = params[:packageName]
    package_version = params[:packageVersion]
    payload_flattening_threshold = params[:payloadFlatteningThreshold]

    begin
      timestamp = Time.now.to_i.to_s
      cmd_line_arguments = {
          '-Input': spec_url,
          '-Namespace': namespace,
          '-OutputDirectory': BASE_DIR + '/' + timestamp,
          '-CodeGenerator': code_generator,
          '-Modeler': modeler,
          '-ClientName': client_name,
          '-PaylodFlatteningThreshold': payload_flattening_threshold,
          '-Header': header,
          '-AddCredentials': add_credentials,
          '-OutputFileName': '',
          '-pn': package_name,
          '-pv': package_version
      }

      file_path = execute_autorest(autorest_version, cmd_line_arguments, timestamp)
      send_data open(file_path, 'rb') {|f| f.read }, filename: "#{timestamp}.tar.gz"
    rescue AutoRestGenerationError => ex
      puts "On error we should render error page. #{ex.msg}"
      render json: { :message => ex.msg }
    end
  end
end
