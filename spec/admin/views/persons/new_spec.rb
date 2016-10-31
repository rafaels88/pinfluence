require 'spec_helper'
require_relative '../../../../apps/admin/views/persons/new'

describe Admin::Views::Persons::New do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/persons/new.html.erb') }
  let(:view)      { Admin::Views::Persons::New.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #foo' do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
