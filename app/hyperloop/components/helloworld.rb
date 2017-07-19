class Helloworld < Hyperloop::Component
  before_mount do
    # any initialization particularly of state variables goes here.
    # this will execute on server (prerendering) and client.
    @helloworldmodels = Helloworldmodel.all
  end

  after_mount do
    # any client only post rendering initialization goes here.
    # i.e. start timers, HTTP requests, and low level jquery operations etc.
  end

  before_update do
    # called whenever a component will be re-rerendered
  end

  before_unmount do
    # cleanup any thing (i.e. timers) before component is destroyed
  end

  render(DIV) do
    show_button
    if MyStore.show_field
      DIV(class: 'formdiv') do
        InputBox()
        show_text
      end
    end
    description_table
  end

  def show_button
    BUTTON(class: 'btn btn-info') do
      'Toggle button'
    end.on(:click) do |evt|
      MyStore.toggle_field
      toggle_logo(evt)
    end
  end

  def toggle_logo(_evt)
    # evt.prevent_default
    logo =Element['img']
    MyStore.show_field ? logo.hide('slow') : logo.show('slow')
  end

  def show_text
    H1 { MyStore.state.field_value.to_s }
  end

  def self.save_description
    Helloworldmodel.create(:description => MyStore.field_value) do |result|
      alert 'unable to save' unless result == true
    end
    alert("Data saved : #{MyStore.field_value}")
    MyStore.mutate.field_value ''
  end

  def description_table
    DIV do
      BR
      TABLE(class: 'table table-hover table-condensed') do
        THEAD do
          TR(class: 'table-danger') do
            TD(width: '33%') { 'SAVED HELLO WORLD' }
          end
        end
        TBODY do
          @helloworldmodels.each do |helloworldmodel|
            DescriptionRow(descriptionparams: helloworldmodel.description)
          end
        end
      end
    end
  end
end
