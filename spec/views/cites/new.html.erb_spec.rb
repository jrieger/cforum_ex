require 'rails_helper'

RSpec.describe "cites/new", type: :view do
  def uconf(name)
    ConfigManager::DEFAULTS[name]
  end
  helper_method :uconf

  before(:each) do
    assign(:cite, create(:cite))
  end

  it "renders new cite form" do
    render

    assert_select "form[action=?][method=?]", cites_path, "post" do
    end
  end
end
