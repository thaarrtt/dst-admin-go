package router

import "github.com/gin-gonic/gin"

func initStaticFile(app *gin.Engine) {
	// API-only mode: No static file serving
	// All web frontend will be served separately
	defer func() {
		if r := recover(); r != nil {
		}
	}()
	// Removed all static file serving configurations
	// The application will now serve only API endpoints
}
