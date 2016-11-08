require 'spec_helper'
require_relative '../../../../apps/admin/controllers/moments/edit'

describe Admin::Controllers::Moments::Edit do
  let(:action) { Admin::Controllers::Moments::Edit.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
