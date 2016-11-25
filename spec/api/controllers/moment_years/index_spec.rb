require 'spec_helper'
require_relative '../../../../apps/api/controllers/moment_years/index'

describe Api::Controllers::MomentYears::Index do
  let(:action) { Api::Controllers::MomentYears::Index.new }
  let(:params) { Hash[] }

  it 'is successful' do
    skip
    response = action.call(params)
    response[0].must_equal 200
  end
end
