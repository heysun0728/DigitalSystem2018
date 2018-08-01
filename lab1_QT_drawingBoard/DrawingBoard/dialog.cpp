#include "dialog.h"
#include "ui_dialog.h"
#include <QPainter>
#include <QPixmap>
#include <QMouseEvent>
#include <QPushButton>
#include <QDebug>
#include <QPen>

Dialog::Dialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::Dialog)
{
    ui->setupUi(this);


    resize(550,335);
    //setStyleSheet("background-color:#BDC3C7;");

    pix = QPixmap(200,200);
    pix.fill(Qt::white);

    pix2=QPixmap(200,200);
    pix2.fill(Qt::white);

    btn_clear=new QPushButton("Clear",this);
    btn_clear->setGeometry(30,250,80,50);
    btn_clear->setFont(QFont("Courier",15,QFont::Bold));
    btn_clear->setStyleSheet("QPushButton{background-color:#BDC3C7;border-radius:10px;color:red;}");
    connect(btn_clear,SIGNAL(clicked()),this,SLOT(clear_clicked()));

    btn_ok=new QPushButton("OK",this);
    btn_ok->setGeometry(120,250,80,50);
    btn_ok->setFont(QFont("Courier",15,QFont::Bold));
    btn_ok->setStyleSheet("QPushButton{background-color:#BDC3C7;border-radius:10px;color:green;}");
    connect(btn_ok,SIGNAL(clicked()),this,SLOT(ok_clicked()));
}

Dialog::~Dialog()
{
    delete ui;
}

void Dialog::ok_clicked(){
    pix2.operator =(pix);
    repaint();
}

void Dialog::clear_clicked(){
    pix.fill(Qt::white);
    pix2.fill(Qt::white);
    repaint();
}

void Dialog::drawLine()
{
        QPainter pp(&pix);
        pp.setPen(QPen(Qt::black, 10));
        pp.drawLine(lastPoint,endPoint);
        lastPoint = endPoint;
        QPainter painter(this);
        painter.drawPixmap(20,20,pix);

        painter.drawPixmap(240,20,pix2);
        //painter.setPen(Qt::NoPen);
}

void Dialog::paintEvent(QPaintEvent *event)
{
    Q_UNUSED(event);
    drawLine();
}

void Dialog::mousePressEvent(QMouseEvent *event)
{
    if (event->button() == Qt::LeftButton)
    {
        lastPoint = event->pos();
    }
}

void Dialog::mouseMoveEvent(QMouseEvent *event)
{
    if(event->buttons()&Qt::LeftButton)
    {
        endPoint = event->pos();
        update();
    }
}

void Dialog::mouseReleaseEvent(QMouseEvent *event)
{
    if(event->button()==Qt::LeftButton)
    {
        endPoint = event->pos();
        update();
    }
}
