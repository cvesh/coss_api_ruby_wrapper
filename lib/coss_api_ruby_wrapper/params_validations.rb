# frozen_string_literal: true

module CossApiRubyWrapper
  class ParamsValidations
    class InvalidParameter < StandardError; end
    attr_reader :errors, :endpoint, :params

    def initialize(endpoint, params)
      @endpoint = endpoint
      @params = params
      @errors = []
    end

    def run!
      case endpoint
      when '/order/add'
        @errors << '"symbol" parameter should be a string representing trading pair, for example: "COSS_ETH"' unless params[:order_symbol] =~ /\w+_\w+/
        @errors << '"price" parameter should be convertable to float and be greater than zero' if params[:order_price] <= 0
        @errors << '"side" parameter should be either BUY or SELL string' unless %w[BUY SELL].include?(params[:order_side])
        @errors << '"amount" parameter should be convertable to float and be greater than zero' if params[:order_size] <= 0
      when '/order/cancel'
        @errors << '"symbol" parameter should be a string representing trading pair, for example: "COSS_ETH"' unless params[:order_symbol] =~ /\w+_\w+/
        @errors << '"order_id" parameter should be a non-empty string' if params[:order_id].empty?
      when '/order/details'
        @errors << '"order_id" parameter should be a non-empty string' if params[:order_id].empty?
      when '/order/trade-detail'
        @errors << '"order_id" parameter should be a non-empty string' if params[:order_id].empty?
      when '/order/list/open'
        @errors << '"limit" parameter should be a positive integer' if params[:limit] <= 0
        @errors << '"symbol" parameter should be a string representing trading pair, for example: "COSS_ETH"' unless params[:symbol] =~ /\w+_\w+/
      when '/order/list/completed'
        @errors << '"limit" parameter should be a positive integer' if params[:limit] <= 0
        @errors << '"symbol" parameter should be a string representing trading pair, for example: "COSS_ETH"' unless params[:symbol] =~ /\w+_\w+/
      when '/order/list/all'
        @errors << '"limit" parameter should be a positive integer' if params[:limit] <= 0
        @errors << '"symbol" parameter should be a string representing trading pair, for example: "COSS_ETH"' unless params[:symbol] =~ /\w+_\w+/
        @errors << '"from_order_id" parameter should be a non-empty string' if params[:from_order_id].empty?
      when '/market-price'
        @errors << '"symbol" parameter should be a string representing trading pair, for example: "COSS_ETH"' unless params[:symbol] =~ /\w+_\w+/
      when '/dp'
        @errors << '"symbol" parameter should be a string representing trading pair, for example: "COSS_ETH"' unless params[:symbol] =~ /\w+_\w+/
      when '/getmarketsummaries'
        @errors << '"symbol" parameter should be a string representing trading pair, for example: "COSS_ETH"' unless params[:symbol] =~ /\w+_\w+/
      end
    end
  end
end
