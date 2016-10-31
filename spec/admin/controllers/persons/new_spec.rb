require 'spec_helper'
require_relative '../../../../apps/admin/controllers/persons/new'

describe Admin::Controllers::Persons::New do
  let(:action) { Admin::Controllers::Persons::New.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
