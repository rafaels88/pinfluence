require 'spec_helper'
require_relative '../../../../apps/admin/controllers/people/destroy'

describe Admin::Controllers::People::Destroy do
  let(:action) { Admin::Controllers::People::Destroy.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
