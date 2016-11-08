require 'spec_helper'
require_relative '../../../../apps/admin/views/moments/edit'

describe Admin::Views::Moments::Edit do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/moments/edit.html.erb') }
  let(:view)      { Admin::Views::Moments::Edit.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #foo' do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
