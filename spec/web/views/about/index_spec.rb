require 'spec_helper'
require_relative '../../../../apps/web/views/about/index'

describe Web::Views::About::Index do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/about/index.html.erb') }
  let(:view)      { Web::Views::About::Index.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #foo' do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
