require 'spec_helper'
require_relative '../../../../apps/admin/views/moments/index'

describe Admin::Views::Moments::Index do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/moments/index.html.erb') }
  let(:view)      { Admin::Views::Moments::Index.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #foo' do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
