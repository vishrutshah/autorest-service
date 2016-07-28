class ValidateController < ApplicationController
  include GenerateHelper

  def index
    unless params[:swagger_url].nil?
      @swagger_url = params[:swagger_url]
    else
      @swagger_url = ''
    end
  end

  def swagger
    autorest_version = params[:autorestVersion]
    spec_url = params[:specUrl]
    modeler = params[:modeler]
    validation_level = params[:validationLevel]

    begin
      timestamp = Time.now.to_i.to_s
      cmd_line_arguments = {
          '-Input': spec_url,
          '-CodeGenerator': 'NONE',
          '-Modeler': modeler,
          '-ValidationLevel': validation_level
      }

      log= execute_autorest(autorest_version, cmd_line_arguments)
      render plain: log
    rescue AutoRestGenerationError => ex
      puts "On error we should render error page. #{ex.msg}"
      render json: { :message => ex.msg }
    end
  end
end
