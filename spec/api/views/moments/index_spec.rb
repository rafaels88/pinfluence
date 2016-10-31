require 'spec_helper'
require_relative '../../../../apps/api/views/moments/index'

describe Api::Views::Moments::Index do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/api/templates/moments/index.html.erb') }
  let(:view)      { Api::Views::Moments::Index.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #foo' do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
