require 'spec_helper'
describe GranulesController do
  describe "GET descriptor_document" do
    context "with valid attributes" do
      it "renders a descriptor document" do
        get :descriptor_document, :format => :xml, :clientId => 'foo', :shortName => 'MOD02QKM', :versionId => '005', :dataCenter => 'LAADS'
        response.should render_template('descriptor_document')
      end
    end
    context "with invalid attributes" do
      it "renders an error" do
        get :descriptor_document, :format => :xml, :client_id => '###'
        response.code.to_s.should match("400")
      end
    end
  end

  describe "GET RestClient error" do
    context "with larger than allowed cursor value" do
      it 'is possible to execute an OpenSearch granule query with a larger than allowed cursor and NOT get an internal server error' do
        VCR.use_cassette 'controllers/granules_cursor_too_large', :record => :once do
          get :index, :format => :atom, :clientId => 'foo', :datasetId => 'MODIS/Terra+Aqua Leaf Area Index/FPAR 8-Day L4 Global 1km SIN Grid V005', :cursor => '174558594'
          assert_equal "400", response.code
          assert_equal "<?xml version=\"1.0\" encoding=\"UTF-8\"?><errors><error>The paging depth (page_num * page_size) of [1745585940] exceeds the limit of 1000000.</error></errors>", response.body
        end
      end
    end
  end
end
