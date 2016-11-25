require 'spec_helper'
require_relative '../../../../apps/admin/controllers/people/index'

describe Admin::Controllers::People::Index do
  let(:action) { Admin::Controllers::People::Index.new }
  let(:params) { Hash[] }

  it 'is successful' do
    skip
    response = action.call(params)
    response[0].must_equal 200
  end
end
