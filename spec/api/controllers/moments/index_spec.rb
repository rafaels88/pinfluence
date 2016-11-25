require 'spec_helper'
require_relative '../../../../apps/api/controllers/moments/index'

describe Api::Controllers::Moments::Index do
  let(:action) { Api::Controllers::Moments::Index.new }
  let(:params) { Hash[] }

  it 'is successful' do
    skip
    response = action.call(params)
    response[0].must_equal 200
  end
end
