require 'spec_helper'
require_relative '../../../../apps/admin/views/people/new'

describe Admin::Views::People::New do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/people/new.html.erb') }
  let(:view)      { Admin::Views::People::New.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #foo' do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
