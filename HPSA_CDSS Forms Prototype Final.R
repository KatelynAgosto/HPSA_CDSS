


library(shiny)
library(shinydashboard)

# Define UI for the combined pain assessment dashboard
ui <- dashboardPage(
  dashboardHeader(title = "Pain Assessments Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Brief Pain Inventory (BPI)", tabName = "assessment", icon = icon("clipboard")),
      menuItem("PAINAD Scale (Nonverbal)", tabName = "painad", icon = icon("stethoscope"))
    )
  ),
  dashboardBody(
    tabItems(
      # Brief Pain Inventory (BPI) Assessment
      tabItem(tabName = "assessment",
              h2("Brief Pain Inventory (BPI) Assessment"),
              fluidRow(
                box(title = "Pain Severity", status = "primary", width = 12,
                    p("1. Please rate your pain by circling the one number that best describes your pain at its worst in the last 24 hours."),
                    sliderInput("worst_pain", "0 - No Pain    10 - Pain as bad as you can imagine", min = 0, max = 10, value = 0, step = 1),
                    p("2. Please rate your pain by circling the one number that best describes your pain at its least in the last 24 hours."),
                    sliderInput("least_pain", "0 - No Pain    10 - Pain as bad as you can imagine", min = 0, max = 10, value = 0, step = 1),
                    p("3. Please rate your pain by circling the one number that best describes your pain on average."),
                    sliderInput("average_pain", "0 - No Pain    10 - Pain as bad as you can imagine", min = 0, max = 10, value = 0, step = 1),
                    p("4. Please rate your pain by circling the one number that tells how much pain you have right now."),
                    sliderInput("current_pain", "0 - No Pain    10 - Pain as bad as you can imagine", min = 0, max = 10, value = 0, step = 1)
                ),
                box(title = "Completion", status = "primary", width = 12,
                    textInput("completed_by", "Completed by:"),
                    actionButton("submit", "Submit", class = "btn-primary"),
                    actionButton("reset", "Reset Form", class = "btn-danger"),
                    verbatimTextOutput("bpi_severity_score")
                )
              )
      ),
      # PAINAD Scale (Nonverbal) Assessment
      tabItem(tabName = "painad",
              h2("PAINAD Scale (Nonverbal) Assessment"),
              fluidRow(
                box(title = "Breathing", status = "primary", width = 12,
                    radioButtons("breathing", "Select breathing score:",
                                 choices = c(
                                   "0 - Normal: Breathing is regular and unlabored" = 0,
                                   "1 - Occasional labored breathing: Includes short periods of hyperventilation" = 1,
                                   "2 - Noisy labored breathing: Includes long periods of hyperventilation or Cheyne-Stokes respirations" = 2))),
                box(title = "Negative Vocalization", status = "primary", width = 12,
                    radioButtons("vocalization", "Select vocalization score:",
                                 choices = c(
                                   "0 - None: No vocalization observed" = 0,
                                   "1 - Occasional moan or groan: May include low-level speech with a negative or disapproving quality" = 1,
                                   "2 - Repeated troubled vocalization: Includes crying, loud moaning, or groaning" = 2))),
                box(title = "Facial Expression", status = "primary", width = 12,
                    radioButtons("facial_expression", "Select facial expression score:",
                                 choices = c(
                                   "0 - Smiling or inexpressive: Calm or neutral expression" = 0,
                                   "1 - Sad or frightened: May include frowning" = 1,
                                   "2 - Facial grimacing: Obvious signs of distress in facial features" = 2))),
                box(title = "Body Language", status = "primary", width = 12,
                    radioButtons("body_language", "Select body language score:",
                                 choices = c(
                                   "0 - Relaxed: Normal body posture and movements" = 0,
                                   "1 - Tense: May include distressed pacing or fidgeting" = 1,
                                   "2 - Rigid: Includes fists clenched, knees pulled up, or striking out" = 2))),
                box(title = "Consolability", status = "primary", width = 12,
                    radioButtons("consolability", "Select consolability score:",
                                 choices = c(
                                   "0 - No need to console: Patient is calm and does not require reassurance" = 0,
                                   "1 - Distracted or reassured by voice or touch: Patient responds positively to reassurance" = 1,
                                   "2 - Unable to console or distract: Patient does not respond to reassurance or consolation" = 2))),
                box(title = "Completion", status = "primary", width = 12,
                    textInput("painad_completed_by", "Completed by:"),
                    actionButton("painad_submit", "Submit", class = "btn-primary"),
                    actionButton("painad_reset", "Reset Form", class = "btn-danger"),
                    verbatimTextOutput("painad_total_score")
                )
              )
      )
      
      )
    )
  )

# Define server logic for the pain assessment and score calculations
server <- function(input, output, session) {
  
  # Calculate BPI Pain Severity Score
  output$bpi_severity_score <- renderText({
    severity_score <- mean(c(input$worst_pain, input$least_pain, input$average_pain, input$current_pain), na.rm = TRUE)
    paste("Pain Severity Score:", round(severity_score, 2), "/ 10")
  })
  
  # Reset BPI form
  observeEvent(input$reset, {
    updateSliderInput(session, "worst_pain", value = 0)
    updateSliderInput(session, "least_pain", value = 0)
    updateSliderInput(session, "average_pain", value = 0)
    updateSliderInput(session, "current_pain", value = 0)
    updateTextInput(session, "completed_by", value = "")
  })
  
  # Submit BPI form
  observeEvent(input$submit, {
    showModal(modalDialog(
      title = "Form Submitted",
      paste("Thank you,", input$completed_by, "for completing the BPI assessment form."),
      easyClose = TRUE
    ))
  })
  
  # Calculate PAINAD Total Score
  output$painad_total_score <- renderText({
    total_score <- sum(as.numeric(input$breathing),
                       as.numeric(input$vocalization),
                       as.numeric(input$facial_expression),
                       as.numeric(input$body_language),
                       as.numeric(input$consolability), na.rm = TRUE)
    paste("Total PAINAD Score:", total_score, "/ 10")
  })
  
  # Reset PAINAD form
  observeEvent(input$painad_reset, {
    updateRadioButtons(session, "breathing", selected = character(0))
    updateRadioButtons(session, "vocalization", selected = character(0))
    updateRadioButtons(session, "facial_expression", selected = character(0))
    updateRadioButtons(session, "body_language", selected = character(0))
    updateRadioButtons(session, "consolability", selected = character(0))
    updateTextInput(session, "painad_completed_by", value = "")
  })
  
  # Submit PAINAD form
  observeEvent(input$painad_submit, {
    showModal(modalDialog(
      title = "PAINAD Form Submitted",
      paste("Thank you,", input$painad_completed_by, "for completing the PAINAD assessment form."),
      easyClose = TRUE
    ))
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
