#' Pushes current plot to imgur.
#'
#' @return The link to the uploaded image (invisible).
#' @importFrom grDevices dev.print png
#' @importFrom utils browseURL
#' @export
#'
#' @examples \dontrun{push_imgur()}
push_imgur <- function() {
  configList <- config_read()

  if (configList$toConsole)
    cat("Pushing current plot.")

  filename <- tempfile(fileext = ".png")
  dev.print(png, filename, width = 1920, height = 1080)
  img <- imguR::upload_image(
    file        = filename,
    title       = "Image uploaded via PushPlot.",
    description = "Image uploaded via PushPlot."
  )
  file.remove(filename)

  if (configList$toClipboard)
    clipr::write_clip(img$link)

  if (configList$openBrowser)
    browseURL(img$link)

  if (configList$toConsole)
    cat('\r', "Pushing current plot. Done!", img$link)
  invisible(img$link)
}

#' Opens a dialog with settings.
#'
#' @return Nothing.
#' @import miniUI
#' @import shiny
#' @export
#'
#' @examples \dontrun{push_imgur_config()}
push_imgur_config <- function() {
  configList <- config_read()

  ui <- miniPage(
    gadgetTitleBar("Settings"),
    miniContentPanel(
      checkboxInput(
        "toConsole",
        "Print link in console.",
        configList$toConsole
      ),
      checkboxInput(
        "toClipboard",
        "Copy link to clipboard.",
        configList$toClipboard
      ),
      checkboxInput(
        "openBrowser",
        "Open in browser after uploading.",
        configList$openBrowser
      )
    )
  )

  server <- function(input, output, session) {
    observeEvent(input$done, {
      configList <- list(
        toConsole   = input$toConsole,
        toClipboard = input$toClipboard,
        openBrowser = input$openBrowser
      )
      config_write(configList)
      stopApp()
    })
  }

  viewer <- paneViewer(300)
  runGadget(ui, server, viewer = viewer)
}

#' Returns the file path to the configuration file.
#'
#' @return File path to the configuration fie.
#'
#' @examples \dontrun{config_filename()}
config_filename <- function() {
  file.path(system.file(package = "PushPlots"), "config.yaml")
}

#' Returns a list with the settings.
#'
#' @return A list with the settings.
#'
#' @examples \dontrun{config_read()}
config_read <- function() {
  yaml::read_yaml(config_filename())
}

#' Writes a list to the configuration file.
#'
#' @param configList A named list.
#' @return Nothing.
#'
#' @examples \dontrun{config_write()}
config_write <- function(configList) {
  yaml::write_yaml(configList, config_filename())
}
