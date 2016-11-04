require 'spec_helper'
require_relative '../../../../apps/admin/controllers/moments/destroy'

describe Admin::Controllers::Moments::Destroy do
  let(:action) { Admin::Controllers::Moments::Destroy.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
