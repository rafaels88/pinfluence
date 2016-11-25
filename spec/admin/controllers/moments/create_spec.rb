require 'spec_helper'
require_relative '../../../../apps/admin/controllers/moments/create'

describe Admin::Controllers::Moments::Create do
  let(:action) { Admin::Controllers::Moments::Create.new }
  let(:params) { Hash[] }

  it 'is successful' do
    skip
    response = action.call(params)
    response[0].must_equal 200
  end
end
