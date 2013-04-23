module Features

  SERVER_ERROR_MSG = "but something went wrong"
  ADMIN_USERNAME = 'admin@local.com'
  ADMIN_PASSWORD = 'admin'

  module SignIn
    def sign_in(username, password)
      fill_in 'user_email', with: username
      fill_in 'user_password', with: password
      click_button 'Sign in'
    end

    def sign_out
      find(:xpath, "//a[@href='#']").click
      click_link 'Sign Out'
    end
  end

  module JobOpening
    def add_job_opening(title, department = '', publish = false, total_seats = 0, filled_seats = 0, hiring_manager = '',
      recruiter = '', country = '', province = '', city = '', description = '')
      click_link 'Job Openings'
      find_link('Add a Job Opening').click
      fill_in 'opening_title', with: title
      select department, :from => 'opening_department_id' if department != ''
      fill_in 'opening_total_no', with: total_seats if total_seats > 0
      fill_in 'opening_filled_no', with: filled_seats if filled_seats > 0
      select hiring_manager, :from => 'opening_hiring_manager_id' if hiring_manager != ''
      select recruiter, :from => 'opening_recruiter_id' if recruiter != ''
      find(:xpath, "//select/option[text()='#{country}'][1]").select_option if country != ''
      select province, :from => 'opening_province' if province !=''
      fill_in 'opening_city', with: city if city != ''
      fill_in 'opening_description', with: description if description != ''
      check 'opening_status' if publish
      click_button 'Save'
      page.should_not have_content(SERVER_ERROR_MSG)
    end

    def job_opening_details(title)
      click_link 'Job Openings'
      click_link title
      page.should have_content(title)
    end

    def edit_job_opening(currentTitle, newTitle, status = '', department = '', total_seats = 0, filled_seats = 0,
      hiring_manager = '', recruiter = '', country = '', province = '', city = '', description = '', interviewer = '')
      click_link 'Job Openings'
      currentStatus = find(:xpath, "//tr[td[contains(., '#{currentTitle}')]]/td[4]").text #will get Draft, Published or Closed
      find(:xpath, "//tr[td[contains(., '#{currentTitle}')]]/td/a", :text => 'Edit').click
      fill_in 'opening_title', with: newTitle
      select department, :from => 'opening_department_id' if department != ''
      fill_in 'opening_total_no', with: total_seats if total_seats > 0
      fill_in 'opening_filled_no', with: filled_seats if filled_seats > 0
      select hiring_manager, :from => 'opening_hiring_manager_id' if hiring_manager != ''
      select recruiter, :from => 'opening_recruiter_id' if recruiter != ''
      find(:xpath, "//select/option[text()='#{country}'][1]").select_option if country != ''
      select province, :from => 'opening_province' if province !=''
      fill_in 'opening_city', with: city if city != ''
      fill_in 'opening_description', with: description if description != ''
      if status != ''
        if currentStatus == 'Draft'
          check 'opening_status' if status == 'published'
        else
          select status, :from => 'opening_status'
        end
      end
      if currentStatus == 'Published'
        if interviewer != ''
          fill_in 'token-input-opening_participant_tokens', with: interviewer
          sleep 2
          find('#token-input-opening_participant_tokens').native.send_keys(:return)
        end
      end
      click_button 'Save'
      page.should_not have_content(SERVER_ERROR_MSG)
    end

    def delete_job_opening(title)
      click_link 'Job Openings'
      find(:xpath, "//tr[td[contains(., '#{title}')]]/td/a", :text => 'Delete').click
      page.driver.browser.switch_to.alert.accept
      page.should_not have_content(SERVER_ERROR_MSG)
    end
  end

  module Candidate
    def add_candidate(name, email, phone, source = '', description = '', department = '', job_opening = '')
      click_link 'Candidates'
      find_link('Add a Candidate').click
      fill_in 'candidate_name', with: name
      fill_in 'candidate_email', with: email
      fill_in 'candidate_phone', with: phone
      fill_in 'candidate_source', with: source if source != ''
      fill_in 'candidate_description', with: description if description != ''
      select department, :from => 'department_ids' if department != ''
      select job_opening, :from => 'openings_ids' if job_opening != ''
      click_button 'Save'
      page.should_not have_content(SERVER_ERROR_MSG)
    end

    def candidate_details(name)
      click_link 'Candidates'
      page.should have_link(name, visible: true)
      first(:link, name).click
      page.should have_content('Information for')
    end

    def edit_candidate(currentName, newName, email, phone)
      click_link 'Candidates'
      find(:xpath, "//tr[td[contains(., '" + currentName + "')]]/td/a", :text => 'Edit').click
      fill_in 'candidate_name', with: newName
      fill_in 'candidate_email', with: email
      fill_in 'candidate_phone', with: phone
      click_button 'Save'
      page.should_not have_content(SERVER_ERROR_MSG)
    end

    def delete_candidate(name)
      click_link 'Candidates'
      find(:xpath, "//tr[td[contains(., '" + name + "')]]/td/a", :text => 'Delete').click
      page.driver.browser.switch_to.alert.accept
      page.should_not have_content(SERVER_ERROR_MSG)
    end

  end
end
