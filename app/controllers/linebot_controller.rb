class LinebotController < ApplicationController
  require 'mechanize'

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head :bad_request
    end

    events = client.parse_events_from(body)

    events.each { |event|
      if event.message['text'] != nil
        # LINEで送られてきた文書を取得
        word = event.message['text']
        # インスタンス生成
        agent = Mechanize.new
      end

      # ページのHTMLを取得
      page = agent.get("https://kotobank.jp/word/#{word}")

      # 要素を取得
      elements = page.search('ex cf')

      # 概要を返す
      response = "hoge"

      case event
      # メッセージが送信された場合
      when Line::Bot::Event::Message
        case event.type
        # メッセージが送られて来た場合
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: response
          }
          client.reply_message(event['replyToken'], message)
        end
      end
    }

    head :ok
  end
end
