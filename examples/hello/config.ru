#!/usr/bin/env falcon --verbose serve -c

require 'async'

class RequestLogger
	def initialize(app)
		@app = app
	end
	
	def call(env)
		logger = Async.logger.with(level: :debug, name: "middleware")
		
		Async(logger: logger) do
			@app.call(env)
		end.wait
	end
end

use RequestLogger

run lambda {|env| Async.logger.debug(self) {env['HTTP_USER_AGENT']}; [200, {}, ["Hello World"]]}
