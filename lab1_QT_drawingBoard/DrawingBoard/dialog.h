#ifndef DIALOG_H
#define DIALOG_H

#include <QDialog>

namespace Ui {
class Dialog;
}

class Dialog : public QDialog
{
    Q_OBJECT

public:
    explicit Dialog(QWidget *parent = 0);
    ~Dialog();

    void drawLine();

protected:
    void paintEvent(QPaintEvent *event);
    void mousePressEvent(QMouseEvent *event);
    void mouseMoveEvent(QMouseEvent *event);
    void mouseReleaseEvent(QMouseEvent *event);

private slots:
    void clear_clicked();
    void ok_clicked();

private:
    Ui::Dialog *ui;
    QPixmap pix,pix2;
    QPoint lastPoint;
    QPoint endPoint;
    QPushButton *btn_clear,*btn_ok;
    QPixmap tempPix;
};

#endif // DIALOG_H
