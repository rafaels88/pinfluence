require 'spec_helper'
require_relative '../../../../apps/admin/controllers/people/update'

describe Admin::Controllers::People::Update do
  let(:action) { Admin::Controllers::People::Update.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
