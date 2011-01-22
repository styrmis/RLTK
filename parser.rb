# Author:		Chris Wailes <chris.wailes@gmail.com>
# Project: 	Ruby Language Toolkit
# Date:		2011/01/19
# Description:	This file contains the base class for parsers that use RLTK.

############
# Requires #
############

# Ruby Language Toolkit
require 'lexers/ebnf'

#######################
# Classes and Modules #
#######################

module RLTK
	class ParsingError < Exception; end
	
	class Parser
		def Parser.inherited(klass)
			klass.class_exec do
				@lexer		= EBNFLexer.new
				@productions	= Hash.new
				@start_state	= nil
				
				#################
				# Class Methods #
				#################
				
				def self.finalize
					items	= Array.new
					sets		= Hash.new
					
					#FIXME
				end
				
				def self.rule(symbol, expression = nil, &action)
					#Set the start symbol if this is the first production
					#defined.
					@start_state ||= symbol
					
					#Grab the existing production or create a new one.
					production = (@productions[symbol] ||= Production.new(symbol))
					
					if expression
						production.clause(expression, action)
					else
						production.instance_exec(&action)
					end
				end
				
				def self.start(state)
					@start_state = state
				end
				
				####################
				# Instance Methods #
				####################
				
				def parse(tokens)
					stacks = Array.new
					#FIXME
				end
			end
		end
		
		class Item
		end
		
		class ItemSet
		end
		
		class Production
			attr_reader :symbol
			attr_reader :clauses
			
			def initialize(symbol)
				@symbol = symbol
				
				@clauses = Array.new
			end
			
			def clause(expression, &action)
				@clauses << Clause.new(expression, action || Proc.new() {})
			end
			
			class Clause
				attr_reader :expression
				attr_reader :action
				
				def initialize(expression, action)
					@expression	= expression
					@action		= action
				end
			end
		end
	end
end
