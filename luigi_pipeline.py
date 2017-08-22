# -*- coding: utf-8 -*-
"""
Created on Mon Jul 03 00:23:22 2017

@author: Jean Michel Arreola Trapala
@contact : jean.arreola@yahoo.com.mx
"""

import luigi
import subprocess
 
class CreateTable(luigi.Task):
 
    def requires(self):
        return []
 
    def output(self):
        return []
 
    def run(self):
        subprocess.call('Rscript create_table.R', shell = True)
        
        
if __name__ == '__main__':
    luigi.run()
