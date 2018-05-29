namespace CodeOnlyDemo
{
    partial class OrderDemo
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.current_lable = new System.Windows.Forms.Label();
            this.current_lable2 = new System.Windows.Forms.Label();
            this.goods_lable = new System.Windows.Forms.Label();
            this.goods_txt = new System.Windows.Forms.TextBox();
            this.btn_submit = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // current_lable
            // 
            this.current_lable.AutoSize = true;
            this.current_lable.Location = new System.Drawing.Point(62, 39);
            this.current_lable.Name = "current_lable";
            this.current_lable.Size = new System.Drawing.Size(59, 12);
            this.current_lable.TabIndex = 0;
            this.current_lable.Text = "当前用户:";
            // 
            // current_lable2
            // 
            this.current_lable2.AutoSize = true;
            this.current_lable2.Location = new System.Drawing.Point(127, 39);
            this.current_lable2.Name = "current_lable2";
            this.current_lable2.Size = new System.Drawing.Size(41, 12);
            this.current_lable2.TabIndex = 1;
            this.current_lable2.Text = "******";
            // 
            // goods_lable
            // 
            this.goods_lable.AutoSize = true;
            this.goods_lable.Location = new System.Drawing.Point(12, 162);
            this.goods_lable.Name = "goods_lable";
            this.goods_lable.Size = new System.Drawing.Size(65, 12);
            this.goods_lable.TabIndex = 2;
            this.goods_lable.Text = "商品名称：";
            // 
            // goods_txt
            // 
            this.goods_txt.Location = new System.Drawing.Point(83, 159);
            this.goods_txt.Name = "goods_txt";
            this.goods_txt.Size = new System.Drawing.Size(189, 21);
            this.goods_txt.TabIndex = 3;
            // 
            // btn_submit
            // 
            this.btn_submit.Location = new System.Drawing.Point(145, 216);
            this.btn_submit.Name = "btn_submit";
            this.btn_submit.Size = new System.Drawing.Size(75, 23);
            this.btn_submit.TabIndex = 4;
            this.btn_submit.Text = "提交";
            this.btn_submit.UseVisualStyleBackColor = true;
            this.btn_submit.Click += new System.EventHandler(this.btn_submit_Click);
            // 
            // OrderDemo
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(455, 261);
            this.Controls.Add(this.btn_submit);
            this.Controls.Add(this.goods_txt);
            this.Controls.Add(this.goods_lable);
            this.Controls.Add(this.current_lable2);
            this.Controls.Add(this.current_lable);
            this.Name = "OrderDemo";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "OrderDemo";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label current_lable;
        private System.Windows.Forms.Label current_lable2;
        private System.Windows.Forms.Label goods_lable;
        private System.Windows.Forms.TextBox goods_txt;
        private System.Windows.Forms.Button btn_submit;
    }
}