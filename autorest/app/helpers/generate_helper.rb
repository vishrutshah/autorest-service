module GenerateHelper
  def generate_tgz(file)
    content = File.read(file)
    ActiveSupport::Gzip.compress(content)
  end
end
