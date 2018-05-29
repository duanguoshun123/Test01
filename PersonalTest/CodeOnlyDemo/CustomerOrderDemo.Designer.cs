namespace CodeOnlyDemo
{
    partial class CustomerOrderDemo
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
            this.customer_order_datagridview = new System.Windows.Forms.DataGridView();
            this.label1 = new System.Windows.Forms.Label();
            this.customerAdd_btn = new System.Windows.Forms.Button();
            this.pre_btn = new System.Windows.Forms.Button();
            this.next_btn = new System.Windows.Forms.Button();
            this.First_btn = new System.Windows.Forms.Button();
            this.last_btn = new System.Windows.Forms.Button();
            this.cur_page_txt = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.to_btn = new System.Windows.Forms.Button();
            this.label_count = new System.Windows.Forms.Label();
            this.refresh_btn = new System.Windows.Forms.Button();
            this.mu_btn = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.customer_order_datagridview)).BeginInit();
            this.SuspendLayout();
            // 
            // customer_order_datagridview
            // 
            this.customer_order_datagridview.AllowUserToAddRows = false;
            this.customer_order_datagridview.AllowUserToDeleteRows = false;
            this.customer_order_datagridview.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.customer_order_datagridview.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.customer_order_datagridview.Location = new System.Drawing.Point(49, 53);
            this.customer_order_datagridview.Name = "customer_order_datagridview";
            this.customer_order_datagridview.ReadOnly = true;
            this.customer_order_datagridview.RowTemplate.Height = 23;
            this.customer_order_datagridview.Size = new System.Drawing.Size(881, 307);
            this.customer_order_datagridview.TabIndex = 0;
            this.customer_order_datagridview.CellContentClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.customer_order_datagridview_CellContentClick);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(420, 28);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(89, 12);
            this.label1.TabIndex = 1;
            this.label1.Text = "客户商品信息表";
            // 
            // customerAdd_btn
            // 
            this.customerAdd_btn.Location = new System.Drawing.Point(855, 17);
            this.customerAdd_btn.Name = "customerAdd_btn";
            this.customerAdd_btn.Size = new System.Drawing.Size(75, 23);
            this.customerAdd_btn.TabIndex = 2;
            this.customerAdd_btn.Text = "添加用户";
            this.customerAdd_btn.UseVisualStyleBackColor = true;
            this.customerAdd_btn.Click += new System.EventHandler(this.customerAdd_btn_Click);
            // 
            // pre_btn
            // 
            this.pre_btn.Location = new System.Drawing.Point(232, 399);
            this.pre_btn.Name = "pre_btn";
            this.pre_btn.Size = new System.Drawing.Size(75, 23);
            this.pre_btn.TabIndex = 3;
            this.pre_btn.Text = "上一页";
            this.pre_btn.UseVisualStyleBackColor = true;
            this.pre_btn.Click += new System.EventHandler(this.pre_btn_Click);
            // 
            // next_btn
            // 
            this.next_btn.Location = new System.Drawing.Point(753, 399);
            this.next_btn.Name = "next_btn";
            this.next_btn.Size = new System.Drawing.Size(75, 23);
            this.next_btn.TabIndex = 4;
            this.next_btn.Text = "下一页";
            this.next_btn.UseVisualStyleBackColor = true;
            this.next_btn.Click += new System.EventHandler(this.next_btn_Click);
            // 
            // First_btn
            // 
            this.First_btn.Location = new System.Drawing.Point(325, 399);
            this.First_btn.Name = "First_btn";
            this.First_btn.Size = new System.Drawing.Size(75, 23);
            this.First_btn.TabIndex = 5;
            this.First_btn.Text = "第一页";
            this.First_btn.UseVisualStyleBackColor = true;
            this.First_btn.Click += new System.EventHandler(this.First_btn_Click);
            // 
            // last_btn
            // 
            this.last_btn.Location = new System.Drawing.Point(654, 399);
            this.last_btn.Name = "last_btn";
            this.last_btn.Size = new System.Drawing.Size(75, 23);
            this.last_btn.TabIndex = 6;
            this.last_btn.Text = "最后一页";
            this.last_btn.UseVisualStyleBackColor = true;
            this.last_btn.Click += new System.EventHandler(this.last_btn_Click);
            // 
            // cur_page_txt
            // 
            this.cur_page_txt.Location = new System.Drawing.Point(485, 399);
            this.cur_page_txt.Name = "cur_page_txt";
            this.cur_page_txt.Size = new System.Drawing.Size(100, 21);
            this.cur_page_txt.TabIndex = 7;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(591, 402);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(29, 12);
            this.label2.TabIndex = 8;
            this.label2.Text = "页数";
            // 
            // to_btn
            // 
            this.to_btn.Location = new System.Drawing.Point(404, 399);
            this.to_btn.Name = "to_btn";
            this.to_btn.Size = new System.Drawing.Size(75, 23);
            this.to_btn.TabIndex = 9;
            this.to_btn.Text = "跳转到";
            this.to_btn.UseVisualStyleBackColor = true;
            this.to_btn.Click += new System.EventHandler(this.to_btn_Click);
            // 
            // label_count
            // 
            this.label_count.AutoSize = true;
            this.label_count.Location = new System.Drawing.Point(853, 402);
            this.label_count.Name = "label_count";
            this.label_count.Size = new System.Drawing.Size(41, 12);
            this.label_count.TabIndex = 10;
            this.label_count.Text = "label3";
            // 
            // refresh_btn
            // 
            this.refresh_btn.Location = new System.Drawing.Point(58, 17);
            this.refresh_btn.Name = "refresh_btn";
            this.refresh_btn.Size = new System.Drawing.Size(75, 23);
            this.refresh_btn.TabIndex = 11;
            this.refresh_btn.Text = "刷新";
            this.refresh_btn.UseVisualStyleBackColor = true;
            this.refresh_btn.Click += new System.EventHandler(this.refresh_btn_Click);
            // 
            // mu_btn
            // 
            this.mu_btn.Location = new System.Drawing.Point(683, 17);
            this.mu_btn.Name = "mu_btn";
            this.mu_btn.Size = new System.Drawing.Size(156, 23);
            this.mu_btn.TabIndex = 12;
            this.mu_btn.Text = "批量添加用户信息";
            this.mu_btn.UseVisualStyleBackColor = true;
            this.mu_btn.Click += new System.EventHandler(this.mu_btn_Click);
            // 
            // CustomerOrderDemo
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1007, 503);
            this.Controls.Add(this.mu_btn);
            this.Controls.Add(this.refresh_btn);
            this.Controls.Add(this.label_count);
            this.Controls.Add(this.to_btn);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.cur_page_txt);
            this.Controls.Add(this.last_btn);
            this.Controls.Add(this.First_btn);
            this.Controls.Add(this.next_btn);
            this.Controls.Add(this.pre_btn);
            this.Controls.Add(this.customerAdd_btn);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.customer_order_datagridview);
            this.Name = "CustomerOrderDemo";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "CustomerOrderDemo";
            this.Load += new System.EventHandler(this.CustomerOrderDemo_Load);
            ((System.ComponentModel.ISupportInitialize)(this.customer_order_datagridview)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.DataGridView customer_order_datagridview;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button customerAdd_btn;
        private System.Windows.Forms.Button pre_btn;
        private System.Windows.Forms.Button next_btn;
        private System.Windows.Forms.Button First_btn;
        private System.Windows.Forms.Button last_btn;
        private System.Windows.Forms.TextBox cur_page_txt;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Button to_btn;
        private System.Windows.Forms.Label label_count;
        private System.Windows.Forms.Button refresh_btn;
        private System.Windows.Forms.Button mu_btn;
    }
}