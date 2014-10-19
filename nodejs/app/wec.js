var wechat = require('wechat');

app.use(express.query()); // Or app.use(express.query());
app.use('/wechat', wechat('R4zBsRtZ8GQjfVTF', function (req, res, next) {
  // ΢��������Ϣ����req.weixin��
  var message = req.weixin;
  if (message.FromUserName === 'diaosi') {
    // �ظ���˿(��ͨ�ظ�)
    res.reply('hehe');
  } else if (message.FromUserName === 'text') {
    //��Ҳ���������ظ�text���͵���Ϣ
    res.reply({
      content: 'text object',
      type: 'text'
    });
  } else if (message.FromUserName === 'hehe') {
    // �ظ�һ������
    res.reply({
      type: "music",
      content: {
        title: "�������ְ�",
        description: "һ������",
        musicUrl: "http://mp3.com/xx.mp3",
        hqMusicUrl: "http://mp3.com/xx.mp3"
      }
    });
  } else {
    // �ظ��߸�˧(ͼ�Ļظ�)
    res.reply([
      {
        title: '�����Ҽҽ��Ұ�',
        description: '����Ů����߸�˧֮��ĶԻ�',
        picurl: 'http://nodeapi.cloudfoundry.com/qrcode.jpg',
        url: 'http://nodeapi.cloudfoundry.com/'
      }
    ]);
  }
}));
