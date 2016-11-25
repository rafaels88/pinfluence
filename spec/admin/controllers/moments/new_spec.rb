require 'spec_helper'
require_relative '../../../../apps/admin/controllers/moments/new'

describe Admin::Controllers::Moments::New do
  let(:action) { Admin::Controllers::Moments::New.new }
  let(:params) { Hash[] }

  it 'is successful' do
    skip
    response = action.call(params)
    response[0].must_equal 200
  end
end
