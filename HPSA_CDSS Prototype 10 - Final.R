


library(shiny)
library(shinydashboard)
library(DT)
library(shinyjs)


# Define Recommendations
recommendations <- list(
  "non_opioids" = HTML("<strong>Non-Opioids</strong><br>
                        <strong>NSAIDs</strong>: Includes drugs like ibuprofen, ketorolac, and selective COX-2 inhibitors (e.g., celecoxib).
                        They inhibit COX enzymes to reduce inflammation and pain; however, they carry risks like gastrointestinal bleeding and renal issues.
                        Prophylactic gastric protection (e.g., proton pump inhibitors) is recommended if used long-term.<br>
                        <strong>Acetaminophen</strong>: Commonly used at a maximum dose of 4000 mg per 24 hours; risks include hepatotoxicity, especially in patients with liver disease. 
                        Additionally, consider acetaminophen as the preferred nonopioid for mild to moderate pain in older adults. 
                        It is often used for postoperative pain management because it has no effect on platelets and fewer adverse effects than NSAIDs. 
                        [*Evidence Grade B*: Well-designed controlled trials and cohort studies in older adults support its use.]<br><br>"),
  
  "opioids" = HTML("<strong>Opioid Analgesic</strong>: Opioids like morphine, oxycodone, hydromorphone, and fentanyl provide potent analgesia by acting on opioid receptors (mu, delta, kappa)
                    Side effects may include respiratory depression, gastrointestinal dysmotility, and sedation.
                    Dosages should be tailored individually, and short-acting opioids can be converted to long-acting options as needed.<br>
                    Additionally, initiate opioid therapy with a 25% to 50% dose reduction and slowly titrate dosage by 25% of that initial dose until there is either a 50% reduction in the patient's pain rating or the patient reports satisfactory pain relief. 
                    Older adults generally receive greater peak and longer duration of action from opioids than younger individuals. 
                    [*Evidence Grade B*: Well-designed controlled trials and cohort studies in older adults support its use.]<br><br>"),
  
  
  "tramadol" = HTML("<strong>Opioids</strong><br>
                   Tramadol causes less respiratory depression in older adults and may impair gastrointestinal motor function less than other opioids at equianalgesic doses. 
                   However, caution must be exercised in patients with hepatic or renal disorders.<br>
                   Using acetaminophen with tramadol may provide additional analgesic relief. Tramadol is commercially available in combination with acetaminophen for short-term moderate pain. 
                   However, this formulation is not appropriate for more severe pain because the recommended maximum daily dose of both acetaminophen and tramadol can be easily exceeded.<br>
                   [*Evidence Grade D: There is evidence of integrative reviews, national clinical practice guidelines, or acute pain research in adults but not specific to older adults.*]<br><br>"),
  
  
  "adjuvants" = HTML("<strong>Adjuvants</strong>: Used alongside non-opioids or opioids to enhance pain relief, especially for specific types of pain.
                      Medications such as gabapentin and pregabalin for neuropathic pain are particularly recommended as part of multimodal therapy for highly opioid-tolerant patients or patients undergoing major surgery associated with substantial pain.
                      Corticosteroids are also used to improve appetite and mood. 
                      These may have renal dose adjustments and require risk-benefit discussion.
                      [*Evidence Grade B*: Well-designed controlled trials and cohort studies in older adults support its use.]<br><br>"),
  
  "avoiding_pain_triggers" = HTML("<strong>Avoiding Pain Triggers</strong>: Includes positioning to prevent spasms, head support, oral care, and skin care to avoid ulcerations or painful conditions like keratitis. 
                                   These interventions are considered part of a holistic approach to pain management. 
                                   Source: Sinha et al., 2023, <em>End-of-life evaluation and management of pain, StatPearls Publishing</em>.<br><br>"),
  
  "psychosocial" = HTML("<strong>Psychosocial Support</strong>: Involves counseling to help patients get affairs in order, establish care goals, and reduce anxiety.
                         Supports include daily grooming, spiritual counseling, and interpersonal relationship improvement to uphold dignity.<br>
                         Plan timing and depth of education based on the older adult’s current pain state. Teach when pain is relatively well-controlled with analgesics. 
                         Pain relief must be a priority. Provide ongoing explanations of procedures or treatments as knowing what to expect can allay fear and anxiety and help to decrease pain. 
                         [*Evidence Grade C*: Observational studies or controlled trials in older adults with inconsistent results]<br><br>")
)

# Define Recommendations List
get_recommendation <- list(
  "Step 1" = HTML(
    paste(
      recommendations[["non_opioids"]],
      recommendations[["adjuvants"]],
      recommendations[["avoiding_pain_triggers"]],
      sep = ""
    )
  ),
  "Step 2" = HTML(
    paste(
      recommendations[["opioids"]],
      recommendations[["tramadol"]],  # Tramadol added only to Step 2
      recommendations[["psychosocial"]],
      recommendations[["non_opioids"]],
      recommendations[["adjuvants"]],
      recommendations[["avoiding_pain_triggers"]],
      sep = ""
    )
  ),
  "Step 3" = HTML(
    paste(
      recommendations[["opioids"]],
      recommendations[["adjuvants"]],
      recommendations[["non_opioids"]],
      sep = ""
    )
  )
)

ui <- dashboardPage(
  dashboardHeader(
    title = span("Hospice Pain Screening and Assessment", style = "font-size: 20px; white-space: normal;"),
    titleWidth = 450
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Pain Screening and Assessment", tabName = "screening", icon = icon("search")),
      menuItem("Patient List and Alerts", tabName = "patient_list", icon = icon("bell"))
    )
  ),
  dashboardBody(
    tags$head(
      tags$style(HTML("
    .btn-soft-red {
      background-color: #ffcccc !important; /* Light red */
      border-color: #ffcccc !important;
      color: black !important;
      font-weight: bold;
    }
  "))
    ),
    tabItems(
      tabItem(tabName = "screening",
              fluidRow(
                # Introduction Section
                box(title = "Introduction", status = "primary", width = 12,
                    HTML("<p>The criteria for using this CDSS will primarily focus on hospice patients and older adults aged 60 and above, emphasizing acute and physical pain. This system is designed to enable pain screening and rapid pain assessment while providing guidance on effective treatment modalities. Exclusions from the CDSS include scenarios involving postoperative care, chronic pain management, or comprehensive evaluations of pain, such as detailed assessments of its location, character, duration, and frequency.</p>")
                ),
                
                # Screening and Assessment Information
                box(title = "Screening and Assessment Info", status = "primary", width = 12,
                    textInput("completed_by", "Screened By:"),
                    dateInput("screening_date", "Date:", value = Sys.Date()),
                    textInput("patient_name", "Patient Name:"),
                    radioButtons("sex", "Sex:", choices = c("Female", "Male")),
                    dateInput("dob", "Date of Birth:", value = ""),
                    actionButton("reset_btn", "Reset", icon = icon("refresh"), class = "btn btn-danger") # Reset Button
                ),
                
                # Admission Section
                box(title = "Admission", status = "primary", width = 12,
                    checkboxGroupInput("pain_screening", "Will the patient be screened for pain?", choices = c("Yes" = "yes", "No" = "no")),
                    uiOutput("screening_reminder_ui")
                ),
                
                # Dynamic UI for Pain Reporting and Assessment Type
                uiOutput("pain_reported_ui"),
                uiOutput("assessment_type_ui"),
                
                # Submit Button
                uiOutput("submit_score_ui"),
                
                # Follow-Up and Recommendations UI
                uiOutput("recommendation_ui"),
                uiOutput("followup_ui") # Follow-Up Reminder Dropdown UI
              )
      )
    )
  )
)

server <- function(input, output, session) {
  
  # Reactive variables
  loop_count <- reactiveVal(0)  # Counter for iterations
  current_step <- reactiveVal("Step 1")  # Tracks the current step
  
  # Reset Button Logic
  observeEvent(input$reset_btn, {
    updateTextInput(session, "completed_by", value = "")
    updateDateInput(session, "screening_date", value = Sys.Date())
    updateTextInput(session, "patient_name", value = "")
    updateRadioButtons(session, "sex", selected = character(0))
    updateDateInput(session, "dob", value = Sys.Date())
    updateCheckboxGroupInput(session, "pain_screening", selected = character(0))
    output$screening_reminder_ui <- renderUI({ NULL })
    output$pain_reported_ui <- renderUI({ NULL })
    output$assessment_type_ui <- renderUI({ NULL })
    output$recommendation_ui <- renderUI({ NULL })
    output$followup_ui <- renderUI({ NULL })
  })
  
  # Validate Date of Birth (Age >= 60)
  observeEvent(input$dob, {
    if (!is.null(input$dob)) {  # Ensure DOB is not NULL
      dob <- as.Date(input$dob)  # Convert input to Date
      age <- as.numeric(difftime(Sys.Date(), dob, units = "weeks")) / 52.25
      if (age < 60) {
        showNotification("Error: Patient must be at least 60 years old.", type = "error")
        updateDateInput(session, "dob", value = NULL)  # Reset the DOB input
      }
    }
  }, ignoreInit = TRUE)  # Avoid validation on app load
  

  # Enforce single-selection behavior for checkboxes
  observeEvent(input$pain_screening, {
    if (length(input$pain_screening) > 1) {
      updateCheckboxGroupInput(session, "pain_screening", selected = tail(input$pain_screening, 1))
    }
  })
  
  output$submit_score_ui <- renderUI({
    # Ensure that input$pain_reported exists and matches the correct conditions
    if (!is.null(input$pain_reported) && ("yes" %in% input$pain_reported || "na" %in% input$pain_reported)) {
      actionButton("submit_score", "Submit Score", icon = icon("check"))
    } else {
      NULL  # Do not display the button
    }
  })
  
  
  # Pain Screening Conditional Logic
  observeEvent(input$pain_screening, {
    req(input$pain_screening)
    if ("no" %in% input$pain_screening) {
      output$screening_reminder_ui <- renderUI({
        actionButton("set_24hr_alert", "Set 24-hour Reminder", icon = icon("bell"), class = "btn btn-danger")
      })
      output$pain_reported_ui <- renderUI({ NULL })  # Clear pain_reported UI
    } else if ("yes" %in% input$pain_screening) {
      output$screening_reminder_ui <- renderUI({ NULL })
      output$pain_reported_ui <- renderUI({
        checkboxGroupInput("pain_reported", "Does the patient report pain?",
                           choices = list("Yes" = "yes", "No" = "no", "N/A - patient is nonverbal" = "na"))
      })
    }
  })
  
  # Enforce Single-Selection Behavior for "Does the patient report pain?"
  observeEvent(input$pain_reported, {
    if (!is.null(input$pain_reported) && length(input$pain_reported) > 1) {
      updateCheckboxGroupInput(session, "pain_reported", selected = tail(input$pain_reported, 1))
    }
  })
  
  
  # Enforce single-selection behavior for "Does the patient report pain?"
  observeEvent(input$pain_reported, {
    req(input$pain_reported)
    if (length(input$pain_reported) > 1) {
      updateCheckboxGroupInput(session, "pain_reported", selected = tail(input$pain_reported, 1))
    }
    # Respond to "Does the patient report pain?" selection
    if ("yes" %in% input$pain_reported) {
      output$assessment_type_ui <- renderUI({
        numericInput("bpi_score", HTML("<br>The BPI assessment can be completed by or in collaboration with the physician, nurse, caregiver, or patient. Complete assessment through link <a href='https://katelyn-agosto.shinyapps.io/HPSAForms/' target='_blank'>HPSAForms</a>.<br><br>Enter BPI Score (0-10):"), value = NULL, min = 0, max = 10)
      })
    } else if ("no" %in% input$pain_reported) {
      output$assessment_type_ui <- renderUI({
        tagList(
          tags$div(
            class = "btn-soft-red",  # Apply the soft red styling to the container
            selectInput("followup_time", "Set Follow-Up Reminder:", 
                        choices = c("4 hours", "8 hours", "12 hours"))
          ),
          HTML("<p>The frequency of follow-up intervals is tailored to the patient's care plan and setting, allowing for timely assessment and intervention. Additional follow-ups may be set at shorter intervals such as 4, 8, or 12 hours to ensure effective pain management. In hospital or nursing home settings, follow-up intervals should reflect the anticipated time frame for therapeutic effects of medication or non-pharmacologic interventions. The initiating nurse or caregiver should determine the timing based on clinical needs. For clinical purposes, record the baseline pain score and reassess at each follow-up interval to monitor the patient’s response to the intervention.</p>")
        )
      })
    } else if ("na" %in% input$pain_reported) {
      output$assessment_type_ui <- renderUI({
        numericInput("painad_score", HTML("<br>The PAINAD assessment must be completed by a physician or nurse. Complete assessment through link <a href='https://katelyn-agosto.shinyapps.io/HPSAForms/' target='_blank'>HPSAForms</a>.<br><br>Enter PAINAD Score (0-10):"), value = NULL, min = 0, max = 10)
      })
    }
  })
  
  observeEvent(input$submit_score, {
    req(input$pain_reported)
    
    # Validate and calculate the score
    score <- if ("yes" %in% input$pain_reported) {
      req(input$bpi_score)
      if (input$bpi_score < 0 || input$bpi_score > 10) {
        showNotification("Error: BPI score must be between 0 and 10.", type = "error")
        return(NULL)  # Prevent further processing
      }
      input$bpi_score
    } else if ("na" %in% input$pain_reported) {
      req(input$painad_score)
      if (input$painad_score < 0 || input$painad_score > 10) {
        showNotification("Error: PAINAD score must be between 0 and 10.", type = "error")
        return(NULL)  # Prevent further processing
      }
      input$painad_score
    } else {
      0
    }
    
    if (score == 0) {
      output$recommendation_ui <- renderUI({
        tagList(
          HTML("<strong>Follow-up required:</strong>"),
          selectInput("followup_time", "Set Follow-Up Reminder:", choices = c("4 hours", "8 hours", "12 hours"))
        )
      })
    } else if (score <= 3) {
      current_step("Step 1")
      output$recommendation_ui <- renderUI({
        tagList(
          get_recommendation[["Step 1"]],
          radioButtons("pain_managed", "Was the patient's pain managed?",
                       choices = c("Yes" = "yes", "No" = "no"),
                       selected = character(0))
        )
      })
    } else if (score >= 4 && score <= 6) {
      current_step("Step 2")
      output$recommendation_ui <- renderUI({
        tagList(
          get_recommendation[["Step 2"]],
          radioButtons("pain_managed", "Was the patient's pain managed?",
                       choices = c("Yes" = "yes", "No" = "no"),
                       selected = character(0))
        )
      })
    } else if (score >= 7) {
      current_step("Step 3")
      output$recommendation_ui <- renderUI({
        tagList(
          get_recommendation[["Step 3"]],
          radioButtons("pain_managed", "Was the patient's pain managed?",
                       choices = c("Yes" = "yes", "No" = "no"),
                       selected = character(0))
        )
      })
    }
  })
  
  
  # Submit Score Logic
  observeEvent(input$submit_score, {
    req(input$pain_reported)
    
    # Calculate the score
    score <- if ("yes" %in% input$pain_reported) {
      req(input$bpi_score)
      input$bpi_score
    } else if ("na" %in% input$pain_reported) {
      req(input$painad_score)
      input$painad_score
    } else {
      0
    }
    
    # Render recommendations based on the score
    output$recommendation_ui <- renderUI({
      recommendation <- if (score <= 3) get_recommendation[["Step 1"]]
      else if (score >= 4 && score <= 6) get_recommendation[["Step 2"]]
      else get_recommendation[["Step 3"]]
      
      tagList(
        recommendation,
        radioButtons("pain_managed", "Was the patient's pain managed?",
                     choices = c("Yes" = "yes", "No" = "no"),
                     selected = character(0)),
        HTML("<p>For additional information on recommendations and treatment modalities, consult the following resources:</p>
           <ul>
             <li><a href='https://geriatricpain.org/sites/geriatricpain.org/files/2021-03/2016_acute_pain_guideline_electronic.pdf' target='_blank'>Acute Pain Management in Older Adults Guideline</a></li>
             <li><a href='https://www.ncbi.nlm.nih.gov/books/NBK554435/' target='_blank'>WHO Analgesic Ladder</a></li>
           </ul>")
      )
    })
  })
  
  
  
  # Continuous Loop for "Was the patient's pain managed?"
  observeEvent(input$pain_managed, {
    req(input$pain_managed)
    
    count <- loop_count()
    
    # Stop looping after 10 iterations
    if (count >= 10) {
      output$recommendation_ui <- renderUI({
        HTML("<strong>Looping has stopped after 10 iterations.</strong>")
      })
      return()
    }
    
    if (input$pain_managed == "yes") {
      loop_count(0)  # Reset counter
      output$recommendation_ui <- renderUI({ NULL })  # Clear recommendations
      output$followup_ui <- renderUI({
        tagList(
          tags$div(
            class = "btn-soft-red",  # Apply soft red styling to the dropdown container
            selectInput("followup_time", "Set Follow-Up Reminder:", 
                        choices = c("4 hours", "8 hours", "12 hours"), 
                        selectize = FALSE)  # Basic dropdown
          ),
          HTML("<p>The frequency of follow-up intervals is tailored to the patient's care plan and setting, allowing for timely assessment and intervention. Additional follow-ups may be set at shorter intervals such as 4, 8, or 12 hours to ensure effective pain management. In hospital or nursing home settings, follow-up intervals should reflect the anticipated time frame for therapeutic effects of medication or non-pharmacologic interventions. The initiating nurse or caregiver should determine the timing based on clinical needs. For clinical purposes, record the baseline pain score and reassess at each follow-up interval to monitor the patient’s response to the intervention.</p>")
        )
      })
    } else if (input$pain_managed == "no") {
      loop_count(count + 1)  # Increment counter
      output$recommendation_ui <- renderUI({
        isolate({  # Isolate current_step to prevent reactivity cycles
          if (current_step() == "Step 1") {
            current_step("Step 2")
            tagList(
              get_recommendation[["Step 2"]],
              radioButtons("pain_managed", "Was the patient's pain managed?",
                           choices = c("Yes" = "yes", "No" = "no"),
                           selected = character(0))
            )
          } else if (current_step() == "Step 2") {
            current_step("Step 3")
            tagList(
              get_recommendation[["Step 3"]],
              radioButtons("pain_managed", "Was the patient's pain managed?",
                           choices = c("Yes" = "yes", "No" = "no"),
                           selected = character(0))
            )
          } else if (current_step() == "Step 3") {
            current_step("Step 2")
            tagList(
              get_recommendation[["Step 2"]],
              radioButtons("pain_managed", "Was the patient's pain managed?",
                           choices = c("Yes" = "yes", "No" = "no"),
                           selected = character(0))
            )
          }
        })
      })
      output$followup_ui <- renderUI({ NULL })
    }
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

