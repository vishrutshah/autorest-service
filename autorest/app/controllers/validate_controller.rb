class ValidateController < ApplicationController
  def index
  end

  def swagger
    params.to_s
    puts "We'll pass this parameters to the AutoRest and collect gzip to be sent back."

    begin

      # file_path = ''
      # send_file file_path
      render :action => 'index'
    rescue Exception
      puts "On error we should render error page."
    end
  end
end
