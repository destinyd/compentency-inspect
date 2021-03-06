@AdminQuestionsNewMultiChoicePage = React.createClass
  submit: (evt)->
    jQuery.ajax
      type: 'POST'
      url: @props.data.submit_url
      data:
        question:
          kind: "multi_choice"
          level: 1
          content: @state.content
          answer:
            choices: @state.choices
            corrects: @state.corrects
          point_ids: @point_ids
    .done (res)=>
      @done res
    .fail (res)=>
      alert res

  handleChoiceBlur: (val)->
    (evt)=>
      choices = @state.choices
      choices = for choice in choices
        choice["text"] = evt.target.value if choice["id"] == val
        choice
      @setState
        choices: choices

  handleContentBlur: (evt)->
    @setState
      content: evt.target.value

  handleCorrectsChange: (val)->
    (evt)=>
      corrects = @state.corrects
      i = corrects.indexOf(val)
      if evt.target.checked
        corrects.push(val) if i < 0
      else
        corrects.splice(i, 1) if i >= 0
      @setState
        corrects: corrects

  addChoice: ->
    choices = @state.choices
    choices.push
      id: jQuery.randstr(8)
      text: ""
    @setState
      choices: choices

  remove: (val)->
    =>
      choices = @state.choices
      i = -1
      for choice, index in choices
        i = index if choice["id"] == val

      if i >= 0
        corrects = @state.corrects
        corrects.splice(corrects.indexOf(val), 1) if corrects.indexOf(val) >= 0
        choices.splice(i, 1)
        @setState
          choices: choices
          corrects: corrects

  change: ->
    $dom = jQuery ReactDOM.findDOMNode @refs.select
    values = $dom.dropdown('get value')
    values = values[values.length - 1]
    @point_ids = values || []

  componentDidMount: ->
    @addChoice()
    @addChoice()
    $dom = jQuery ReactDOM.findDOMNode @refs.select
    $dom.dropdown()

  getInitialState: ->
    @point_ids = []
    content: ""
    choices: []
    corrects: []

  render: ->
    <div className="ui segment">
      <div className="data-form">
        <div className="ui small form">
          <div className="field">
            <label style={{width: "6rem"}}>
              <span className="required">* </span>
              <span>题目内容：</span>
            </label>
            <div className="wrapper" style={{flex: "1 1 0%"}}>
              <textarea rows="5" onBlur={@handleContentBlur} defaultValue={@state.content}>
              </textarea>
            </div>
          </div>
          <div className="field">
            <label style={{width: "6rem"}}>
              <span className="required">* </span>
              <span>答案：</span>
            </label>
            <div className="wrapper" style={{flex: "1 1 0%"}}>
              {
                for choice, i in @state.choices
                  value = choice["id"]
                  text = choice["text"]
                  checked = false
                  for correct in @state.corrects
                    checked = true if correct == value
                  <div key={value}>
                    <input type="checkbox" name="corrects" checked={checked} value={value} onChange={@handleCorrectsChange(value)} />
                    <input type="text" defaultValue={text} onBlur={@handleChoiceBlur(value)} />
                    {
                      if i + 1 > 2
                        <a href="javascript:;" onClick={@remove(value)}>
                          <i className="icon remove"></i>
                        </a>
                    }
                  </div>
              }
            </div>
          </div>
          <div className="field">
            <div className="ui button icon" onClick={@addChoice}>
              <i className="icon plus"></i>
              添加一个选项
            </div>
          </div>

          <div className="field">
            <label style={{width: "6rem"}}>
              <span>知识点：</span>
            </label>
            <div className="wrapper" style={{flex: "1 1 0%"}}>
              <select className='ui dropdown' onChange={@change} ref='select' multiple>
                {
                  for value, text of @props.data.points
                    <option key={value} value={value}>{text}</option>
                }
              </select>
            </div>
          </div>

          <div className="field">
            <label style={{width: "6rem"}}>
              <span>
              </span>
            </label>
            <div className="wrapper" style={{flex: "1 1 0%"}}>
              <a className="ui button green" href="javascript:;" onClick={@submit}>
                <i className="icon check">
                </i>
                确定保存
              </a>
              <a className="ui button" href="javascript:;" onClick={@cancel}>取消</a>
            </div>
          </div>
        </div>
      </div>
    </div>

  done: (res)->
    Turbolinks.visit @props.data.cancel_url

  cancel: ->
    Turbolinks.visit @props.data.cancel_url


@AdminQuestionsNewSingleChoicePage = React.createClass
  submit: (evt)->
    jQuery.ajax
      type: 'POST'
      url: @props.data.submit_url
      data:
        question:
          kind: "single_choice"
          level: 1
          content: @state.content
          answer:
            choices: @state.choices
            correct: @state.correct
          point_ids: @point_ids
    .done (res)=>
      @done res
    .fail (res)=>
      alert res

  handleChoiceBlur: (val)->
    (evt)=>
      choices = @state.choices
      choices = for choice in choices
        choice["text"] = evt.target.value if choice["id"] == val
        choice
      @setState
        choices: choices

  handleContentBlur: (evt)->
    @setState
      content: evt.target.value

  handleCorrectClick: (evt)->
    @setState
      correct: evt.target.value

  addChoice: ->
    choices = @state.choices
    choices.push
      id: jQuery.randstr(8)
      text: ""
    @setState
      choices: choices

  remove: (val)->
    =>
      choices = @state.choices
      i = -1
      for choice, index in choices
        i = index if choice["id"] == val

      if i >= 0
        correct = @state.correct
        correct = null if correct == val

        choices.splice(i, 1)
        @setState
          choices: choices
          correct: correct

  change: ->
    $dom = jQuery ReactDOM.findDOMNode @refs.select
    values = $dom.dropdown('get value')
    values = values[values.length - 1]
    @point_ids = values || []

  componentDidMount: ->
    @addChoice()
    @addChoice()
    $dom = jQuery ReactDOM.findDOMNode @refs.select
    $dom.dropdown()

  getInitialState: ->
    @point_ids = []
    content: ""
    choices: []
    correct: null

  render: ->
    <div className="ui segment">
      <div className="data-form">
        <div className="ui small form">
          <div className="field">
            <label style={{width: "6rem"}}>
              <span className="required">* </span>
              <span>题目内容：</span>
            </label>
            <div className="wrapper" style={{flex: "1 1 0%"}}>
              <textarea rows="5" onBlur={@handleContentBlur} defaultValue={@state.content}>
              </textarea>
            </div>
          </div>
          <div className="field">
            <label style={{width: "6rem"}}>
              <span className="required">* </span>
              <span>答案：</span>
            </label>
            <div className="wrapper" style={{flex: "1 1 0%"}}>
              {
                for choice, i in @state.choices
                  value = choice["id"]
                  text = choice["text"]
                  checked = @state.correct == value
                  <div key={value}>
                    <input type="radio" name="correct" checked={checked} value={value} onClick={@handleCorrectClick} />
                    <input type="text" defaultValue={text} onBlur={@handleChoiceBlur(value)} />
                    {
                      if i + 1 > 2
                        <a href="javascript:;" onClick={@remove(value)}>
                          <i className="icon remove"></i>
                        </a>
                    }
                  </div>
              }
            </div>
          </div>
          <div className="field">
            <div className="ui button icon" onClick={@addChoice}>
              <i className="icon plus"></i>
              添加一个选项
            </div>
          </div>

          <div className="field">
            <label style={{width: "6rem"}}>
              <span>知识点：</span>
            </label>
            <div className="wrapper" style={{flex: "1 1 0%"}}>
              <select className='ui dropdown' onChange={@change} ref='select' multiple>
                {
                  for value, text of @props.data.points
                    <option key={value} value={value}>{text}</option>
                }
              </select>
            </div>
          </div>

          <div className="field">
            <label style={{width: "6rem"}}>
              <span>
              </span>
            </label>
            <div className="wrapper" style={{flex: "1 1 0%"}}>
              <a className="ui button green" href="javascript:;" onClick={@submit}>
                <i className="icon check">
                </i>
                确定保存
              </a>
              <a className="ui button" href="javascript:;" onClick={@cancel}>取消</a>
            </div>
          </div>
        </div>
      </div>
    </div>

  done: (res)->
    Turbolinks.visit @props.data.cancel_url

  cancel: ->
    Turbolinks.visit @props.data.cancel_url

@AdminQuestionsNewBoolPage = React.createClass
  render: ->
    {
      TextAreaField
      SelectField
      MultipleSelectField
      Submit
    } = DataForm

    layout =
      label_width: '6rem'

    selects = 
      "true": "正确"
      "false": "错误"

    <div className='ui segment'>
      <SimpleDataForm
        model='question'
        post={@props.data.submit_url}
        data={
          {
            kind: "bool"
            level: 1
          }
        }
        done={@done}
        cancel={@cancel}
      >
        <TextAreaField {...layout} label='题目内容：' name='content' required />
        <SelectField {...layout} label='答案：' name='answer' required values={selects} />
        <MultipleSelectField {...layout} label='知识点：' name='point_ids' values={@props.data.points} />
        <Submit {...layout} text='确定保存' with_cancel='取消' />
      </SimpleDataForm>
    </div>

  done: (res)->
    Turbolinks.visit @props.data.cancel_url

  cancel: ->
    Turbolinks.visit @props.data.cancel_url

@AdminQuestionsNewEssayPage = React.createClass
  render: ->
    {
      TextAreaField
      MultipleSelectField
      Submit
    } = DataForm

    layout =
      label_width: '6rem'

    <div className='ui segment'>
      <SimpleDataForm
        model='question'
        post={@props.data.submit_url}
        data={
          {
            kind: "essay"
            level: 1
          }
        }
        done={@done}
        cancel={@cancel}
      >
        <TextAreaField {...layout} label='题目内容：' name='content' required />
        <TextAreaField {...layout} label='参考答案：' name='answer' required />
        <MultipleSelectField {...layout} label='知识点：' name='point_ids' values={@props.data.points} />
        <Submit {...layout} text='确定保存' with_cancel='取消' />
      </SimpleDataForm>
    </div>

  done: (res)->
    Turbolinks.visit @props.data.cancel_url

  cancel: ->
    Turbolinks.visit @props.data.cancel_url

@AdminQuestionsNewFileUploadPage = React.createClass
  render: ->
    {
      TextAreaField
      MultipleSelectField
      Submit
    } = DataForm

    layout =
      label_width: '6rem'

    <div className='ui segment'>
      <SimpleDataForm
        model='question'
        post={@props.data.submit_url}
        data={
          {
            kind: "file_upload"
            level: 1
          }
        }
        done={@done}
        cancel={@cancel}
      >
        <TextAreaField {...layout} label='题目内容：' name='content' required />
        <TextAreaField {...layout} label='参考答案：' name='answer' required />
        <MultipleSelectField {...layout} label='知识点：' name='point_ids' values={@props.data.points} />
        <Submit {...layout} text='确定保存' with_cancel='取消' />
      </SimpleDataForm>
    </div>

  done: (res)->
    Turbolinks.visit @props.data.cancel_url

  cancel: ->
    Turbolinks.visit @props.data.cancel_url



