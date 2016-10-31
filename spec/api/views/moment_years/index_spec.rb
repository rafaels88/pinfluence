require 'spec_helper'
require_relative '../../../../apps/api/views/moment_years/index'

describe Api::Views::MomentYears::Index do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/api/templates/moment_years/index.html.erb') }
  let(:view)      { Api::Views::MomentYears::Index.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #foo' do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
