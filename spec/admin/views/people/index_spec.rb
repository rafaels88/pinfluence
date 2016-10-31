require 'spec_helper'
require_relative '../../../../apps/admin/views/people/index'

describe Admin::Views::People::Index do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/people/index.html.erb') }
  let(:view)      { Admin::Views::People::Index.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #foo' do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
