require File.join(File.dirname(__FILE__), '../lib/gh_serve.rb')
describe GhServe do
  before :each do
    #@gh_serve = double(GhServe)
  end

  it "should throw InvalidUrl when no url" do
    invalid_urls = [nil, '', 'http://any-invalid-url222.com']
    invalid_urls.each do |url|
      lambda { GhServe.new(url).raw_content }.should raise_error URI::InvalidURIError
    end
  end

  describe "#new_file_url" do
    before :each do
      @base = "http://b.com"
      @gh_serve = GhServe.new("#{@base}/nested/index.html")
    end

    it "return inchanged absolute path" do
      file_url = "http://c.com/styles.css"
      @gh_serve.new_file_url(file_url).should == file_url
    end

    it "return serving path with relative-absolute path" do
      file_url = "/styles/styles.css"
      expected_url = format(GhServe.serving_url, "#{@base}#{file_url}")
      @gh_serve.new_file_url(file_url).should == expected_url
    end

    it "return serving path with relative path" do
      file_url = "styles.css"
      expected_url = format(GhServe.serving_url, "#{@base}/nested/#{file_url}")
      @gh_serve.new_file_url(file_url).should == expected_url
    end

  end
end
