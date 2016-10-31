require 'spec_helper'
require_relative '../../../../apps/admin/controllers/moments/index'

describe Admin::Controllers::Moments::Index do
  let(:action) { Admin::Controllers::Moments::Index.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
