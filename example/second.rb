class Second < First
  path '/second'

  get '2' do
    "Two"
  end
end
