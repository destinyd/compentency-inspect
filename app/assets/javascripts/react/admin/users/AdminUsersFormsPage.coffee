@AdminUsersNewPage = React.createClass
  render: ->
    {
      TextInputField
      PasswordField
      SelectField
      Submit
    } = DataForm

    layout =
      label_width: '6rem'

    roles =
      'admin': '管理员'
      'normal': '测试者'

    <div className='ui segment'>
      <SimpleDataForm
        model='user'
        post={@props.data.submit_url}
        done={@done}
        cancel={@cancel}
      >
        <TextInputField {...layout} label='姓名：' name='name' required />
        <TextInputField {...layout} label='登录名：' name='login' required />
        <PasswordField {...layout} label='密码：' name='password' required />
        <SelectField {...layout} label='角色：' name='role' values={roles} />
        <Submit {...layout} text='确定保存' with_cancel='取消' />
      </SimpleDataForm>
    </div>

  done: (res)->
    Turbolinks.visit @props.data.cancel_url

  cancel: ->
    Turbolinks.visit @props.data.cancel_url


@AdminUsersEditPage = React.createClass
  render: ->
    {
      TextInputField
      PasswordField
      SelectField
      Submit
    } = DataForm

    layout =
      label_width: '6rem'

    <div className='ui segment'>
      <SimpleDataForm
        model='user'
        data={@props.data.user}
        put={@props.data.submit_url}
        done={@done}
        cancel={@cancel}
      >
        <TextInputField {...layout} label='姓名：' name='name' required />
        <TextInputField {...layout} label='登录名：' name='login' required />
        <PasswordField {...layout} label='重设密码：' name='password' />
        <Submit {...layout} text='确定保存' with_cancel='取消' />
      </SimpleDataForm>
    </div>

  done: (res)->
    Turbolinks.visit @props.data.cancel_url

  cancel: ->
    Turbolinks.visit @props.data.cancel_url