require 'spec_helper'
require_relative '../../../../apps/web/controllers/about/index'

describe Web::Controllers::About::Index do
  let(:action) { Web::Controllers::About::Index.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
