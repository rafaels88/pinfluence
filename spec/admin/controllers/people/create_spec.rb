require 'spec_helper'
require_relative '../../../../apps/admin/controllers/people/create'

describe Admin::Controllers::People::Create do
  let(:action) { Admin::Controllers::People::Create.new }
  let(:params) { Hash[] }

  it 'is successful' do
    skip
    response = action.call(params)
    response[0].must_equal 200
  end
end
