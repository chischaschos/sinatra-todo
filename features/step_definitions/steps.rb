Given(/^I go to the home page$/) do
  visit '/'
end

Given(/^I go to the sign in page$/) do
  visit '/'
  click_link 'Already have an account?'
end

When(/^I submit the sign up form$/) do
  fill_in :email, with: 'test@test.com'
  fill_in :password, with: '123test123'
  click_button 'Sign Up'
end

When(/^I submit the sign in form$/) do
  fill_in :email, with: 'test@test.com'
  fill_in :password, with: '123test123'
  click_button 'Sign In'
end

Then(/^I should see the TODO dashboard$/) do
  expect(page).to have_content("sign out")
end

Given(/^I already have an account$/) do
  Todo::Models::User.create email: 'test@test.com', password: '123test123'
end

When(/^I add the "(.*?)" item$/) do |description|
  click_link 'add'
  fill_in :description, with: description
  click_button 'Create'
end

Then(/^I should only see these items:$/) do |table|
  step 'I should see the TODO dashboard'
  descriptions = table.rows.flatten

  doc = Nokogiri::HTML(page.body)
  expect(doc.xpath('count(//tbody/tr)')).to eq descriptions.count
  descriptions.each do |description|
    expect(doc.xpath("//td[contains(text(), '#{description}')]")).not_to be_empty
  end
end

Then(/^I can delete the "(.*?)"$/) do |description|
  remove_link = find :xpath, "//tr[td//text()[contains(., '#{description}')]]/td[last()]/a[text() = 'remove']"
  remove_link.click
end

Then(/^I edit the "(.*?)" to "(.*?)"$/) do |from_description, to_description|
  edit_link = find :xpath, "//tr[td//text()[contains(., '#{from_description}')]]/td[last()]/a[text() = 'edit']"
  edit_link.click
  fill_in :description, with: to_description
  click_button 'Save'
end

Then(/^I mark as completed "(.*?)"$/) do |description|
  edit_link = find :xpath, "//tr[td//text()[contains(., '#{description}')]]/td[last()]/a[text() = 'edit']"
  edit_link.click
  check :completed
  click_button 'Save'
end
