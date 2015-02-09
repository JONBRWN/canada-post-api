def canada_post_credentials
  @canada_post_credentials ||= credentials["development"]
end

def canada_post_production_credentials
  @canada_post_production_credentials ||= credentials["production"]
end

private

def credentials
  @credentials ||= begin
    YAML.load_file("#{File.dirname(__FILE__)}/../config/canada_post_credentials.yml")
  end
end

