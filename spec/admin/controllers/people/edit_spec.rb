require 'spec_helper'
require_relative '../../../../apps/admin/controllers/people/edit'

describe Admin::Controllers::People::Edit do
  let(:action) { Admin::Controllers::People::Edit.new }
  let(:params) { Hash[] }

  it 'is successful' do
    skip
    response = action.call(params)
    response[0].must_equal 200
  end
end
