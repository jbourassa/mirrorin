require File.join(File.dirname(__FILE__), '../lib/mirror.rb')
describe Mirror do

  it "should throw InvalidUrl when no url" do
    invalid_urls = [ [nil, nil], ['', ''], ['any-invalid-url222', '/'] ]
    invalid_urls.each do |url|
      lambda { Mirror.new(*url).content }.should raise_error URI::InvalidURIError
    end
  end

  describe "#build_uri" do
    it "should switch to https if domain is in https list" do
      mirror = Mirror.new('raw.github.com', '/some/file.html')
      mirror.build_uri.should == 'https://raw.github.com/some/file.html'
    end

    it "should use http if domain isn't in https list" do
      mirror = Mirror.new('non-https-domain.com', '/file.html')
      mirror.build_uri.should == 'http://non-https-domain.com/file.html'
    end
  end

  describe "#headers" do
    it "should set Content-Type" do
      mirror = Mirror.new('domain.com', '/file.html')
      mirror.headers["Content-Type"].should == 'text/html'
    end
  end

end
