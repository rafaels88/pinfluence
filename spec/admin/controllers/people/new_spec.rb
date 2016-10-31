require 'spec_helper'
require_relative '../../../../apps/admin/controllers/people/new'

describe Admin::Controllers::People::New do
  let(:action) { Admin::Controllers::People::New.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
